FROM archlinux

COPY fs /

RUN pacman -Syy && \
pacman-key --init && \
pacman -S --noconfirm archlinux-keyring && \
pacman-key --populate && \
pacman-key --refresh-keys

RUN pacman-key --init

# RUN pacman -Syyuu --noconfirm && \
RUN pacman -Sy && \
pacman -S --noconfirm archiso make archlinuxcn-keyring rust git neovim openssh cmake && \
sed -i "/StrictHostKeyChecking/s/.*/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
pacman -Scc --noconfirm

CMD make
