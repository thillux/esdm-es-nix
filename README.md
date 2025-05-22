This repository contains a build definition for the kernel modules of ESDM (Entropy Source and DRNG Manager), for reference, see:

* (Website)[https://www.chronox.de/esdm/]
* (Github Repository)[https://github.com/smuellerDD/esdm]

# Usage instructions

```nix
# patch kernel (works for kernel version >=6.3)
boot.kernelPatches = [
  {
    name = "esdm_sched_es_hook";
    patch =
      "${pkgs.esdm.src}/addon/linux_esdm_es/0001-ESDM-scheduler-entropy-source-hooks_6.4.patch";
  }
  {
    name = "esdm_inter_es_hook";
    patch =
      "${pkgs.esdm.src}/addon/linux_esdm_es/0002-ESDM-interrupt-entropy-source-hooks_6.4.patch";
  }
];

boot.kernelModules = [ "esdm_es" ];

boot.extraModulePackages = [ config.boot.kernelPackages.esdm_es.out ];

boot.extraModprobeConfig = ''
    options esdm_es esdm_hash_name=sha3-512
'';
```