;;; nx7-theme.el --- Custom Emacs theme by nx7 -*- lexical-binding: t; -*-

(deftheme nx7 "A minimal cyberpunk-inspired dark theme.")

(let ((class '((class color) (min-colors 89)))
      (bg         "#000000")   ;; Pure black background
      (fg         "#ffffff")   ;; Pure white foreground
      (keyword    "#39ff14")   ;; Neon green keywords
      (string     "#C9A0DC")   ;; Lavender grey strings
      (comment    "#888888")   ;; Grey comments
      (space      "#444444")   ;; Grey spaces
      (trailing   "#880000")   ;; Trailing spaces (dark red)
      (inactive-bg "#0a0a0a")  ;; Dim inactive windows
      (line-num   "#444444")   ;; Line numbers
      (modeline-bg "#111111")
      (modeline-fg "#ffffff")
      (completion-bg "#111111")
      (completion-fg "#ffffff")
      (completion-selection-bg "#333333")
      (org-block-bg "#111111")
      (org-block-border "#333333"))

  (custom-theme-set-faces
   'nx7

   ;; Default colors
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(cursor ((,class (:background ,keyword))))
   `(region ((,class (:background ,completion-selection-bg))))

   ;; Font-lock (syntax highlighting)
   `(font-lock-keyword-face ((,class (:foreground ,keyword :weight bold))))
   `(font-lock-function-name-face ((,class (:foreground ,keyword :weight semi-bold))))
   `(font-lock-string-face ((,class (:foreground ,string))))
   `(font-lock-comment-face ((,class (:foreground ,comment :slant italic))))
   `(font-lock-type-face ((,class (:foreground ,fg))))
   `(font-lock-variable-name-face ((,class (:foreground ,fg))))
   `(font-lock-builtin-face ((,class (:foreground ,keyword))))
   `(font-lock-constant-face ((,class (:foreground ,fg))))

   ;; Line numbers
   `(line-number ((,class (:foreground ,line-num :background ,bg))))
   `(line-number-current-line ((,class (:foreground ,fg :background ,bg :weight bold))))

   ;; Modeline
   `(mode-line ((,class (:background ,modeline-bg :foreground ,modeline-fg :box nil))))
   `(mode-line-inactive ((,class (:background ,inactive-bg :foreground ,comment :box nil))))

   ;; Minibuffer & prompts
   `(minibuffer-prompt ((,class (:foreground ,keyword :weight bold))))

   ;; Whitespace-mode
   `(whitespace-space ((,class (:background ,bg :foreground ,space))))
   `(whitespace-tab ((,class (:background ,bg :foreground ,space))))
   `(whitespace-newline ((,class (:foreground ,space))))
   `(whitespace-trailing ((,class (:background ,bg :foreground ,trailing))))

   ;; Inactive window dimming
   `(internal-border ((,class (:background ,inactive-bg))))
   `(fringe ((,class (:background ,bg))))

   ;; Completions (Vertico, Company, Ivy)
   `(completions-common-part ((,class (:foreground ,keyword))))
   `(completions-first-difference ((,class (:foreground ,keyword))))
   `(completions-annotation ((,class (:foreground ,comment))))

   `(vertico-current ((,class (:background ,completion-selection-bg :foreground ,fg))))

   `(company-tooltip ((,class (:background ,completion-bg :foreground ,completion-fg))))
   `(company-tooltip-selection ((,class (:background ,completion-selection-bg :foreground ,fg))))
   `(company-tooltip-common ((,class (:foreground ,keyword))))
   `(company-tooltip-annotation ((,class (:foreground ,comment))))

   ;; Org-mode blocks
   `(org-block ((,class (:background ,org-block-bg :foreground ,fg))))
   `(org-block-begin-line ((,class (:background ,org-block-bg :foreground ,org-block-border))))
   `(org-block-end-line ((,class (:background ,org-block-bg :foreground ,org-block-border))))

   ;; Org-mode titles
   `(org-level-1 ((,class (:foreground ,keyword :weight bold))))
   `(org-level-2 ((,class (:foreground ,string :weight bold))))
   `(org-level-3 ((,class (:foreground "#66ccff" :weight bold))))
   `(org-level-4 ((,class (:foreground "#AAAAAA" :weight bold))))
   `(org-level-5 ((,class (:foreground "#888888" :weight bold))))
   `(org-level-6 ((,class (:foreground "#777777" :weight bold))))
   `(org-level-7 ((,class (:foreground "#666666" :weight bold))))
   `(org-level-8 ((,class (:foreground "#555555" :weight bold))))

   ;; Comments for org
   `(org-code ((,class (:foreground ,string))))
   `(org-quote ((,class (:slant italic :foreground ,comment))))
   )
  )

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'nx7)

;;; nx7-theme.el ends here
