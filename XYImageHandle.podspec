Pod::Spec.new do |s|
s.name         = "XYImageHandle"         # 项目名称
s.version      = "0.1.0"        # 版本号 与 你仓库的 标签号 对应
s.license      = "MIT"          # 开源证书
s.summary      = "A delightful TextField of PhoneNumber" # 项目简介

s.homepage     = "https://github.com/xuxueyong" # 你的主页
s.source       = { :git => "https://github.com/xuxueyong/XYImageHandle.git", :tag => "#{s.version}" }#你的仓库地址，不能用SSH地址
s.source_files = ["Sources/*.swift"] # 你代码的位置
s.swift_version = "4.2"
s.requires_arc = true # 是否启用ARC
s.platform     = :ios, "10.0" #平台及支持的最低版本
s.frameworks   = "UIKit", "Foundation" #支持的框架

# User
s.author             = { "xueyong" => "794334810@qq.com" } # 作者信息
s.social_media_url   = "https://github.com/xuxueyong" # 个人主页
end

