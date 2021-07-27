local wezterm = require 'wezterm';

wezterm.on("showww", function(window, pane)
  wezterm.log_info(window);
end)


-- 右上にバッテリと時計を表示するサンプル
wezterm.on("update-right-status", function(window, pane)
  -- "Wed Mar 3 08:14"
  local date = wezterm.strftime("%a %b %-d %H:%M ");
  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end
  window:set_right_status(wezterm.format({
    {Text=bat .. "   "..date},
  }));
end)

-- A helper function for my fallback fonts
function font_with_fallback(name, params)
  local names = {name, "Font Awesome 5 Brands", "Font Awesome 5 Free", "Noto Color Emoji", "Last Resort"}
  return wezterm.font_with_fallback(names, params)
end

return {
  debug_key_events = true,
  default_prog = {"/usr/local/bin/bash", "-l"},

  use_ime = true,
  color_scheme = "Raycast_Dark",
  -- フォントリガチャを無効化
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
  -- フォントを白源にする
  -- font = font_with_fallback('HackGen'),
  font_size = 10.0,
  -- フォントサイズを変えてもウィンドウサイズは変えないようにする
  adjust_window_size_when_changing_font_size = false,
  -- タブを常に表示する（default）
  hide_tab_bar_if_only_one_tab = false,
  -- 起動時にウィンドウを最大化する
  initial_rows = 24,
  initial_cols = 80,
  -- タブバーを下にする
  tab_bar_at_bottom = true,
  -- スクロールバーを表示する
  enable_scroll_bar = true,
  -- スクロールバッファを増やす（default=3500)
  scrollback_lines = 50000,

  keys = {
    {key="V", mods="CMD", action=wezterm.action{PasteFrom="Clipboard"}},
    {key="F", mods="CMD", action="ToggleFullScreen"},
    {key="Z", mods="CMD", action="TogglePaneZoomState"},
    -- 
    {key="p", mods="CMD", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="p", mods="CMD|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},


    {key="L", mods="CMD", action="ShowLauncher"},
    {key="V", mods="CTRL", action=wezterm.action{EmitEvent="showww"}},
    {key="H", mods="CTRL|OPT|SHIFT", action="ShowTabNavigator"},
    {key="H", mods="CTRL|OPT|SHIFT", action="ShowTabNavigator"},
  },

  -- アクティブでないPaneをデフォルトより更に暗くする
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.8,
  },

  -- シェルを exit 0 以外で終了したときに [Process completed] の表示のままPaneが閉じないのを閉じるようにする
  exit_behavior = "Close",
  -- ウィンドウを閉じる時に確認ダイアログを表示させない (default=AlwaysPrompt)
  --window_close_confirmation = "NeverPrompt",
  -- クローズ時に確認ダイアログを出さないプロセス名
  skip_close_confirmation_for_processes_named = {
    "bash", "sh", "zsh", "fish", "tmux"
  },

  -- 自動で wezterm-mux-server の起動とGUI接続が行われるようにする。ウィンドウを閉じてもタブや分割やその上のプロセスは失われない。
  --unix_domains = {{name = "unix", connect_automatically = true}}
}

