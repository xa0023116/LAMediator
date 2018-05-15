Pod::Spec.new do |s|
s.name = 'JKMediator'
s.version = '0.1.1'
s.license = 'MIT'
s.summary = 'Simple NetWorking Kit'
s.homepage = 'https://github.com/lwq718691587/JKMediator'
s.authors = { '刘伟强' => '718691587@qq.com' }
s.source = { :git => "https://github.com/lwq718691587/JKMediator.git", :tag => s.version.to_s}
s.requires_arc = true
s.ios.deployment_target = '8.0'

s.source_files = 'JKMediator/**/*'


end
