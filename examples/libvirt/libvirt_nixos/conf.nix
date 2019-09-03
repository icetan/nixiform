{ ... }: {
  boot.kernelParams = [
    "console=ttyS0,19200"
    "earlyprint=serial,ttyS0,19200"
  ];
}
