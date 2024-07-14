cur_dateTime=$(shell date +%Y-%m-%d-%H-%m)
filename="archlinux-$(cur_dateTime)-x86_64.iso"

default: copy_nvim_files
	@mkarchiso -v -w build -o out releng
	@cd out; sha256sum * > $(filename).sha256
	@pacman -Scc --noconfirm

get_nvim_config:
	@echo Syncing github520 hosts
	@sh -c 'curl https://raw.hellogithub.com/hosts >> /etc/hosts'
	@echo Getting nvim Files.
	@git clone git@github.com:lI15SO0/nvim-config.git /root/.config/nvim --depth=1 --branch lsp_not_include
	@echo Installing nvim plugins.
	@nvim --headless +q
	@echo Install plugins done.

copy_nvim_files: get_nvim_config
	cp /root/.config/nvim /releng/airootfs/root/.config/nvim -rf
	cp /root/.local/share/nvim /releng/airootfs/root/.local/share/nvim -rf

clean:
	@rm build -rfv
	@rm out -rfv
