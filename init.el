(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://stable.melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa-stable" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (json-mode js2-mode company-tern treemacs company-web))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Configure web-mode
(require 'web-mode)

;; Configure Company
(require 'company)                                   ; load company mode

(setq company-minimum-prefix-length 1)            ; WARNING, probably you will get perfomance issue if min len is 0!
(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-tooltip-align-annotations 't)          ; align annotations to the right tooltip border
(setq company-idle-delay 0)                         ; decrease delay before autocompletion popup shows
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;; Company-web
(require 'company-css)
(require 'company-web-html)                          ; load company mode html backend
;; and/or
(require 'company-web-jade)                          ; load company mode jade backend
(require 'company-web-slim)                          ; load company mode slim backend

;; you may key bind, for example for web-mode:
(add-hook 'web-mode-hook (lambda()
			   (set (make-local-variable 'company-backends) '(company-tern company-web-html company-css))
			   (company-mode t)))

;; Company-tern
(require 'company-tern)
(add-hook 'js2-mode-hook (lambda()
			   (set (make-local-variable 'company-backends) '(company-tern))
			   (tern-mode)
			   (company-mode)))

;; Enable JavaScript completion between <script>...</script> etc.
(advice-add 'company-tern :before
	    #'(lambda (&rest _)
		(if (equal major-mode 'web-mode)
		    (let ((web-mode-cur-language
			   (web-mode-language-at-pos)))
		      (if (or (string= web-mode-cur-language "javascript")
			      (string= web-mode-cur-language "jsx"))
			  (unless tern-mode (tern-mode))
			(if tern-mode (tern-mode -1)))))))

;; Define auto complete for company
(define-key company-mode-map (kbd "C-;") 'company-complete)


;; Set default modes based on extensions
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(treemacs)
