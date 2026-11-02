FROM redhat/ubi10-minimal

COPY MariaDB.repo /etc/yum.repos.d/

RUN set -eux ; \
    microdnf update -y ; \
    microdnf install -y mariadb cronie git ; \
    microdnf clean all


# RUN set -eux ; \
#         microdnf install -y gnupg2; \
# 	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME ; \
# 	curl --fail https://archive.mariadb.org/PublicKey --output /tmp/MariaDB-Server-GPG-KEY ; \
# 	gpg --batch --import /tmp/MariaDB-Server-GPG-KEY; \
# 	gpg --batch --armor --export 177F4010FE56CA3336300305F1656F24C74CD1D8 > /tmp/MariaDB-Server-GPG-KEY ; \
# 	rpmkeys --import /tmp/MariaDB-Server-GPG-KEY ; \
# 	rm -rf "$GNUPGHOME" /tmp/MariaDB-Server-GPG-KEY ; \
#         unset GNUPGHOME ; \
#         microdnf update -y ; \
#         microdnf install -y mariadb mariadb-backup cronie git; \
#         microdnf clean all ;

CMD crond -n
