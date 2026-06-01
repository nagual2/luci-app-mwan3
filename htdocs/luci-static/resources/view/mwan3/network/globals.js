'use strict';
'require form';
'require view';

return view.extend({

	render: function () {
		let m, s, o;

		m = new form.Map('mwan3', _('MultiWAN Manager - Globals'));

		s = m.section(form.NamedSection, 'globals', 'globals');

		o = s.option(form.Value, 'mmx_mask', _('Firewall mask'),
			_('Enter value in hex, starting with <code>0x</code>'));
		o.datatype = 'hex(4)';
		o.default = '0x3F00';

		o = s.option(form.Flag, 'logging', _('Logging'),
			_('Enables global firewall logging'));

		o = s.option(form.ListValue, 'loglevel', _('Loglevel'),
			_('Firewall loglevel'));
		o.default = 'notice';
		o.value('emerg', _('Emergency'));
		o.value('alert', _('Alert'));
		o.value('crit', _('Critical'));
		o.value('error', _('Error'));
		o.value('warning', _('Warning'));
		o.value('notice', _('Notice'));
		o.value('info', _('Info'));
		o.value('debug', _('Debug'));
		o.depends('logging', '1');

		o = s.option(form.DynamicList, 'rt_table_lookup',
			_('Routing table lookup'),
			_('Also scan this Routing table for connected networks'));
		o.datatype = 'uinteger';
		o.value('220', _('Routing table %d').format('220'));

		o = s.option(form.Flag, 'track_host_routes', _('Track host routes (nagual2)'),
			_('Install /32 or /128 routes for each track_ip in the per-interface routing table (IPv6 multi-tunnel).'));
		o.default = '1';
		o.rmempty = true;

		o = s.option(form.Value, 'connected_ipv6_min_prefixlen', _('IPv6 connected min prefix length'),
			_('Do not add IPv6 routes shorter than this prefix length to mwan3_connected_ipv6 (skips WG split-default ::/1).'));
		o.datatype = 'range(1,128)';
		o.placeholder = '32';
		o.default = '32';
		o.rmempty = true;

		return m.render();
	}
})
