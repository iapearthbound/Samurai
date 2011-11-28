/*
 *  Copyright (C) 2009 Samsung Electronics
 *  Minkyu Kang <mk7.kang@samsung.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#ifndef __MAX17040_BATTERY_H_
#define __MAX17040_BATTERY_H_

struct max17040_platform_data {
	int (*battery_online)(void);
	int (*charger_online)(void);
	int (*charger_enable)(void);
	int (*power_supply_register)(struct device *parent,
		struct power_supply *psy);
	void (*power_supply_unregister)(struct power_supply *psy);
	u16 rcomp_value;
};

#define BATTERY_FG_ADJUSTMENT_DEFAULT 9430
#ifdef CONFIG_BATTERY_MAX17040_FG_ADJUSTMENT
#define BATTERY_FG_ADJUSTMENT_MAX 9900
#define BATTERY_FG_ADJUSTMENT_MIN 9400
#endif /* CONFIG_BATTERY_MAX17040_FG_ADJUSTMENT */

#endif
