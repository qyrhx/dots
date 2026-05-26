(deftheme modus-summertime-light
  "A light Modus theme with pink/purple Summertime vibes.")

;; Set overrides BEFORE loading the theme
(setq modus-themes-operandi-color-overrides
      '((bg-main . "#fff0f2")
        (bg-dim . "#fbe6ef")
        (bg-alt . "#f5dae6")
        (bg-active . "#e6cadd")
        (bg-inactive . "#f7e6ef")
        (red . "#d00000")
        (green . "#006800")
        (yellow . "#8a6000")
        (blue . "#0000d0")
        (magenta . "#a000a0")
        (cyan . "#006a6a")))

;; Load the base theme
(load-theme 'modus-operandi t)

(provide-theme 'modus-summertime-light)
