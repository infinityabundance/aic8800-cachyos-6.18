all:
	$(MAKE) -C drivers/aic8800/aic8800_fdrv
	$(MAKE) -C drivers/aic8800/aic8800_btlpm

clean:
	$(MAKE) -C drivers/aic8800/aic8800_fdrv clean
	$(MAKE) -C drivers/aic8800/aic8800_btlpm clean
