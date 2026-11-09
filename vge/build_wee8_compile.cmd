@echo on
set PATH=C:\Projects\depot_tools;%PATH%
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set DEPOT_TOOLS_UPDATE=0
set GYP_MSVS_VERSION=2022
cd /d C:\Projects\v8-build\v8 || exit /b 3
call gn gen out.gn\x64.release "--args=target_os=\"win\" target_cpu=\"x64\" v8_use_external_startup_data=false v8_enable_i18n_support=true icu_use_data_file=true is_debug=false v8_static_library=true is_clang=false use_custom_libcxx=false strip_debug_info=true symbol_level=0 v8_enable_pointer_compression=true v8_enable_sandbox=false v8_enable_maglev=true v8_enable_webassembly=true" || exit /b 10
call ninja -k 0 -C out.gn\x64.release wee8 || exit /b 11
exit /b 0
