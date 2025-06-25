if true then
	return {}
end

return {
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			smear_to_cmd = false,
			legacy_computing_symbols_support = true,
			legacy_computing_symbols_support_vertical_bars = true,
			cursor_color = "#808080",
			stiffness = 0.8,
			trailing_stiffness = 0.5,
			stiffness_insert_mode = 0.7,
			trailing_stiffness_insert_mode = 0.7,
			damping = 1,
			distance_stop_animating = 0.5,
		},
	},
}
