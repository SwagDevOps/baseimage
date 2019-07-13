# Setup ``dropbear`` server

Sample config directory structure:

```
/boot/ssh/
├── authorized_keys
│   └── root
├── host_rsa
└── host_rsa.pem
```

``host_rsa`` file SHOULD be mounted, or it will be generated
it can be converted from a PEM file (``host_rsa.pem``).
Files found in ``/boot/ssh/authorized_keys`` will be copied,
to the corresponding users ``.ssh`` directories.

## Generate ``host_rsa.pem`` file

```sh
yes | ssh-keygen -t rsa -b 4096 -N '' -f host_rsa.pem -m PEM -C "your_email@example.com"
```
