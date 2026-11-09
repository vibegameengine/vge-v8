@echo on
set VERSION=11.8.172
set WS=C:\Projects\v8-build\backend-v8
set PATH=C:\Projects\depot_tools;%PATH%
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set DEPOT_TOOLS_UPDATE=0
set GYP_MSVS_VERSION=2022

cd /d %WS% || exit /b 1
call npm ci --ignore-scripts || exit /b 2

cd /d C:\Projects\v8-build\v8 || exit /b 3
call node %WS%\node-script\do-gitpatch.js -p %WS%\patches\remove_uchar_include_v11.8.172.patch || exit /b 4
call node %WS%\node-script\do-gitpatch.js -p %WS%\patches\win_dll_v11.8.172.patch || exit /b 5
call node %WS%\node-script\do-gitpatch.js -p %WS%\patches\enable_wee8_v11.8.172.patch || exit /b 6
call node %WS%\node-script\rep.js build\config\win\BUILD.gn || exit /b 7
call node %WS%\node-script\add_arraybuffer_new_without_stl.js . %VERSION% || exit /b 8
call node %WS%\node-script\patchs.js . %VERSION% || exit /b 9

call gn gen out.gn\x64.release "--args=target_os=\"win\" target_cpu=\"x64\" v8_use_external_startup_data=false v8_enable_i18n_support=false is_debug=false v8_static_library=true is_clang=false use_custom_libcxx=false strip_debug_info=true symbol_level=0 v8_enable_pointer_compression=false v8_enable_sandbox=false v8_enable_maglev=false v8_enable_webassembly=false" || exit /b 10
call ninja -C out.gn\x64.release wee8 || exit /b 11
exit /b 0
