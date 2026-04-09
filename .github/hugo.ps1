param(
    [switch]$Clean,
    [switch]$Build
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$HugoDir = Join-Path $ProjectRoot ".github\hugo"

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Clean-TempFiles {
    Write-ColorOutput Cyan "正在清理临时文件..."
    
    $ItemsToRemove = @(
        (Join-Path $HugoDir "public"),
        (Join-Path $HugoDir "resources\_gen"),
        (Join-Path $ProjectRoot "public"),
        (Join-Path $HugoDir ".hugo_build.lock"),
        (Join-Path $ProjectRoot "hugo_stats.json")
    )
    
    foreach ($Item in $ItemsToRemove) {
        if (Test-Path $Item) {
            Write-Output "删除: $Item"
            Remove-Item $Item -Recurse -Force
        }
    }
    
    Write-ColorOutput Green "清理完成！"
}

function Sync-Content {
    Write-ColorOutput Cyan "正在同步内容..."
    
    $ContentDir = Join-Path $HugoDir "content"
    
    if (Test-Path (Join-Path $ContentDir "2026*")) {
        Remove-Item (Join-Path $ContentDir "2026*") -Recurse -Force
    }
    
    Copy-Item (Join-Path $ProjectRoot "2026*") $ContentDir -Recurse -Force
    
    $IndexPath = Join-Path $ContentDir "_index.md"
    Copy-Item (Join-Path $ProjectRoot "README.md") $IndexPath -Force
    
    $FrontMatter = @"
---
title: HackNews Digest
---

"@
    $CurrentContent = Get-Content $IndexPath -Raw
    $FrontMatter + $CurrentContent | Set-Content $IndexPath -NoNewline
    
    Write-ColorOutput Green "内容同步完成！"
}

function Start-HugoServer {
    Write-ColorOutput Cyan "正在启动 Hugo 开发服务器..."
    Write-ColorOutput Yellow "请确保已安装 Hugo Extended 版本"
    
    Sync-Content
    
    Set-Location $HugoDir
    hugo server -D --navigateToChanged
}

function Build-HugoSite {
    Write-ColorOutput Cyan "正在构建 Hugo 静态网站..."
    
    Sync-Content
    
    Set-Location $HugoDir
    hugo --minify
    
    Write-ColorOutput Green "构建完成！输出目录: $(Join-Path $HugoDir "public")"
}

if ($Clean) {
    Clean-TempFiles
} elseif ($Build) {
    Clean-TempFiles
    Build-HugoSite
} else {
    Write-ColorOutput Magenta "HackNews Digest - Hugo 本地开发脚本"
    Write-Output ""
    Write-Output "使用方法:"
    Write-Output "  .\hugo.ps1              - 启动开发服务器"
    Write-Output "  .\hugo.ps1 -Clean       - 清理临时文件"
    Write-Output "  .\hugo.ps1 -Build       - 构建静态网站"
    Write-Output ""
    
    Start-HugoServer
}
