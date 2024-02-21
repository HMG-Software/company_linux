# install.sh
... is executed in chroot environment directly after installation - or on 1st boot.

1. **check drives**
```bash
lsblk
```

2. **decrypt drive**
```bash
sudo cryptsetup luksOpen /dev/nvme0n1p3 cryptdata
sudo lvscan
sudo vgchange -ay
```

3. **mount decrypted drive**
```bash
sudo mount /dev/mapper/data-root /mnt
```

4. **chroot**
```bash
sudo mount /dev/nvme0n1p1 /mnt/boot/efi
for i in /dev /dev/pts /proc /sys /run; do sudo mount -R $i /mnt$i; done
sudo chroot /mnt
```

5. **install.sh**
navigate to home, clone and execute `install.sh`
```bash
cd /mnt/home/hmg
git clone https://github.com/HMG-Software/company_linux.git --single-branch --filter=tree:0
cd company_linux
./install.sh
```

6. **restart**
be sure to unplug thumb drive

7. **post-install.sh**
```bash
bash company_linux/post-install.shell
```

8. **register company docker registry**

9. **Enjoy!**

---

sources: [system76/pop-recovery](https://support.system76.com/articles/pop-recovery/)
