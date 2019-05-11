platform :ios, '10.0'

target 'RxSwiftWidgets' do
  use_frameworks!

  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'

  target 'RxSwiftWidgetsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'RxSwiftWidgetsDemo' do
  use_frameworks!
  
  pod 'RxSwiftWidgets', :path => '.'
  
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'Resolver', '~> 1.0'

end
