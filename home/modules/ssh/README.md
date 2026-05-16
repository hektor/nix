# SSH keys

* primary keys (host-specific, non-resident)
* backup key (shared, resident)

## generate keys

### YubiKey 01 - `host_01`

```sh
ssh-keygen -t ed25519-sk \
  -O verify-required \
  -f ~/.ssh/id_ed25519_sk \
  -C "h@host_01"
```

### YubiKey 01 — `host_02`

```sh
ssh-keygen -t ed25519-sk \
  -O verify-required \
  -f ~/.ssh/id_ed25519_sk \
  -C "h@host_02"
```

### YubiKey 02 - `host_*`

```sh
ssh-keygen -t ed25519-sk \
  -O resident \
  -O verify-required \
  -f ~/.ssh/id_ed25519_sk_bak \
  -C "backup"
```

## register keys

when you the primary key (`id_ed25519_sk.pub`), make sure to also register the
backup key (`id_ed25519_sk_bak.pub`) if needed.

## recovery scenarios

| scenario | recovery |
|---|---|
| primary key file lost | generate new primary key on that device, re-register (use backup key) |
| primary YubiKey lost  | generate new primary keys on all devices using new YubiKey (use backup key) |
| backup key file lost | regenerate from backup YubiKey resident key (use `ssh-keygen -K`) |
| backup YubiKey lost | generate resident backup key, distribute across hosts, re-register (use primary key) |

## references

* <https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html>
