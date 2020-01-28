# TPM

If you don't own a Yubikey device it's recommanded to use the TPM to generate your ssh key.

```bash
$ paci tpm2-pkcs11 tpm2-abrmd
$ sudo systemct enable --now tpm2-abrmd.service
$ tpm2_ptool init
$ tpm2_ptool addtoken --pid=1 --label=mysshkey --sopin=XXXX --userpin=YYYY
$ tpm2_ptool addkey --label=mysshkey --userpin=YYYY --algorithm=ecc256
$ ssh-keygen -D /usr/lib/pkcs11/libtpm2_pkcs11.so > ~/.ssh/mysshkey.pub
```

Then to prevent to add the library each time as parameters, add this in your `~/.ssh/config`.

```
Host *
    IdentitiesOnly yes
    IdentityFile ~/.ssh/mysshkey.pub
    PKCS11Provider /usr/lib/pkcs11/libtpm2_pkcs11.so
    IdentityAgent none
    PubkeyAuthentication yes
```
