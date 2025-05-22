{ lib, stdenv, kernel, kmod, esdm }:

let
  patchedKernel = kernel.override {
    kernelPatches = [
      {
        name = "esdm_sched_es_hook";
        patch =
          "${esdm.src}/addon/linux_esdm_es/0001-ESDM-scheduler-entropy-source-hooks_6.4.patch";
      }
      {
        name = "esdm_inter_es_hook";
        patch =
          "${esdm.src}/addon/linux_esdm_es/0002-ESDM-interrupt-entropy-source-hooks_6.4.patch";
      }
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "esdm_es";
  inherit (esdm) version;
  inherit (esdm) src;

  sourceRoot = "source/addon/linux_esdm_es";

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = [ kmod ] ++ patchedKernel.moduleBuildDependencies;

  makeFlags = patchedKernel.makeFlags ++ [
    "KBUILD_OUTPUT=${patchedKernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNELRELEASE=${patchedKernel.modDirVersion}"
    "KERNEL_DIR=${patchedKernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A patchedKernel module for esdm entropy gathering";
    homepage = "http://www.chronox.de/esdm.html";
    license = [ licenses.gpl2Only licenses.bsd2 ];
    maintainers = with maintainers; [ thillux ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "6.3";
  };
})

