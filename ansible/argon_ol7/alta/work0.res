resource work0 {
        
        meta-disk internal;
        device /dev/drbd0;
        disk /dev/sda8;

        net {
                verify-alg sha256;
        }

        on srv01-<nome_cartorio> {
                address 10.0.0.21:7789;
        }

        on srv02-<nome_cartorio> {
                address 10.0.0.22:7789;
        }
}
