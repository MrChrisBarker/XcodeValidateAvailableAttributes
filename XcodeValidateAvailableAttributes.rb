
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module AlertType
    WARNING = "warning"
    ERROR = "error"
end

class ValidateAvailableAttributes
    
    def validate
        
        target = ARGV[0]
        alert_type = ARGV[1] == "warn" ? AlertType::WARNING : AlertType::ERROR
        
        version = find_version_number.to_f
        
        swift_files = Dir["**/*.swift"]
        
        has_check = false
        swift_files.each do |swift_file|
            
            if exclude_list.any? { |word| swift_file.include?(word) }
                next
            end

            File.readlines(swift_file).each do |swift_line|
                if swift_line.include? "#available(iOS"
                    available_version_check = swift_line.string_between_markers("available(iOS", ", ").strip.to_f
                    puts "available: #{available_version_check}, version: #{version}"
                    has_check = available_version_check <= version
                    
                    if has_check
                        $stderr.puts "#{swift_file}:0: #{alert_type}: #{swift_file} has @available check #{available_version_check}"
                    end
                    
                    break
                end
            end
        end
        
        # Correct exit code if we want to flag as a compiler error
        if has_check && alert_type == AlertType::ERROR
            exit 1
        end
        
        exit 0
        
    end
    
    def find_version_number
        
        found_target = false
        found_target_config = false
        target_sdk = ""
        buildConfigurations = ""
        target = ARGV[0]
        
        swift_files = Dir["**/*.xcodeproj/project.pbxproj"]
        
        project_file_path = swift_files.first
        File.readlines(project_file_path).each do |project_line|
            if project_line.include? "Build configuration list for PBXNativeTarget \"#{target}\" */ = {"
                found_target = true
            end
            
            # Get buildConfigurations should be next few lines along
            if found_target == true and project_line.include? " /* Debug */,"
                buildConfigurations = project_line.split('/*').first.strip
                break
            end
            
        end
        
        # Read file again as build configuration is actually above it's declaration
        File.readlines(project_file_path).each do |project_line|
            
            # Found target config file
            if found_target == true and buildConfigurations != "" and project_line.include? "#{buildConfigurations} /* Debug */ = {"
                found_target_config = true
            end
            
            if found_target_config == true and project_line.include? "IPHONEOS_DEPLOYMENT_TARGET ="
                target_sdk = project_line.string_between_markers("= ", ";")
                break
            end
            
        end
        
        
        puts "Target found: #{target_sdk}"
        return target_sdk
        
    end
    
    def check_file(file, string)
        File.foreach(file).detect { |line| line.include?(string) }
    end
    
end

# Exclude list, (exmaple below excludes all Cocoapods directory
def exclude_list
    files_exclude = []
    files_exclude += ["Pods/"]
end

# String Extension
class String
    def string_between_markers marker1, marker2
        self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
    end
end

ValidateAvailableAttributes.new.validate
