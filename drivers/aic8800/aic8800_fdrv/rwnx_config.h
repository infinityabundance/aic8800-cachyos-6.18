#ifndef RWNX_CONFIG_H
#define RWNX_CONFIG_H

/* Default platform limits for FullMAC builds. */
#ifndef NX_REMOTE_STA_MAX
#define NX_REMOTE_STA_MAX 10
#endif

#ifndef NX_REMOTE_STA_MAX_FOR_OLD_IC
#define NX_REMOTE_STA_MAX_FOR_OLD_IC 4
#endif

#ifndef NX_VIRT_DEV_MAX
#define NX_VIRT_DEV_MAX 4
#endif

#ifndef CONFIG_USER_MAX
#define CONFIG_USER_MAX 4
#endif

#ifndef NX_MU_GROUP_MAX
#define NX_MU_GROUP_MAX 8
#endif

#ifndef CONFIG_BR_SUPPORT_BRNAME
#define CONFIG_BR_SUPPORT_BRNAME "br0"
#endif

#ifndef CONFIG_RWNX_UM_HELPER_DFLT
#define CONFIG_RWNX_UM_HELPER_DFLT "/bin/true"
#endif

#ifndef NX_TXQ_CNT
#define NX_TXQ_CNT 5
#endif

#ifndef NX_TX_MAX_RATES
#define NX_TX_MAX_RATES 4
#endif

#ifndef NX_TXDESC_CNT
#define NX_TXDESC_CNT NX_TXQ_CNT
#endif

#ifndef NX_CHAN_CTXT_CNT
#define NX_CHAN_CTXT_CNT 4
#endif

#endif
