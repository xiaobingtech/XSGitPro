# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GitSimulator' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitSimulator
  pod 'RATreeView', :git => 'https://github.com/fandongtongxue/RATreeView.git'
 end

target 'XSGitPro' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for XSGitPro
  pod 'RATreeView', :git => 'https://github.com/fandongtongxue/RATreeView.git'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
            end
        end
    end
end
