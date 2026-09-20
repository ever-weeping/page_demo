Pod::Spec.new do |s|
  s.name         = 'demoResource'
  s.version      = '0.0.1'
  s.summary      = 'Demo alert & toast components'
  s.description  = '页面弹窗/Toast 组件库（本地开发用）'
  s.homepage     = 'https://example.com/demoResource'
  s.license      = { :type => 'MIT', :text => 'Copyright (c) 2026 ali_mahai' }
  s.author       = { 'ali_mahai' => 'ali_mahai@example.com' }

  # 本地用 :path 引用时不需要 source 字段，发布时才要加
  s.source       = { :path => '.' }

  s.platform     = :ios, '15.0'
  s.swift_version = '5.0'
  # 注意：你的源码在 demoResource/demoResource/ 下，要多一层通配
  s.source_files = 'demoResource/**/*.swift'
end