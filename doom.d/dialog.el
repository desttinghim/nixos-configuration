;; ;;; dialogc.el -*- lexical-binding: t; -*-

;; (defvar dialogc-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     ;; (define-key map [foo] 'sample-do-foo)
;;     map)
;;   "Keymap for `dialogc-mode'.")

;; (defvar dialogc-mode-syntax-table
;;   (let ((table (make-syntax-table)))
;;     (modify-syntax-entry ?\% "< 12" table)
;;     (modify-syntax-entry ?\n ">" table)
;;     table)
;;   "Syntax table for `dialogc-mode'.")

;; ;; (defvar dialogc-font-lock-keywords
;; ;;     '(("#\\w+?\\b" . 'font-lock-constant-face)
;; ;;       ("$\\w*?\\b" . 'font-lock-variable-name-face)
;; ;;       ("~" . 'font-lock-negation-char-face)
;; ;;       ("(\\(?:\\(?:[$#]\\w+\\)\\|\\([[:alnum:]-+_]+\\)\\|\\(\\*\\)\\|\\(?: \\)\\)+)"
;; ;;        (1 'font-lock-function-name-face)
;; ;;        (2 'font-lock-preprocessor-face))))

;; (defconst dialogc-font-lock-defaults
;;   `((
;;      ("*" . font-lock-builtin-face)
;;      ("\\($[^ )\n]?+\\)" (1 font-lock-variable-name-face))
;;      ("\\(#[^ )\n]?+\\)" (1 font-lock-constant-face))
;;      ))
;;   "Keyword highlighting for dialogc mode.")

;; (defvar dialogc-mode-hook nil
;;   "*List of functions to call when entering dialogc mode.*")

;; (define-derived-mode dialogc-mode text-mode "dialogc"
;;   "Major mode for editing dialogc story files."
;;   :syntax-table dialogc-mode-syntax-table
;;   (setq-local font-lock-defaults dialogc-font-lock-defaults))

;; (provide 'dialogc)

;; https://gist.github.com/PaulStanley/7d9d989495d687385822b194a5c59d56
;; These are predicates that appear at the *front* of a ()

(defvar dialog-predicates
  '( "Print Words"
     "actor container"
     "actor-supporter"
     "animate"
     "any key"
     "anywhere into"
     "appearance"
     "append"
     "before"
     "bound"
     "breakpoint"
     "clarify location of"
     "command"
     "compiler version"
     "consultable"
     "container"
     "current player"
     "descr"
     "dict"
     "direction"
     "direction"
     "display memory statistics"
     "door"
     "edible"
     "empty"
     "ensure"
     "every tick"
     "fail"
     "female"
     "fine where it is"
     "first try"
     "from"
     "fungible"
     "get input"
     "get key"
     "get number from"
     "held"
     "in-seat"
     "instead of"
     "interpreter supports undo"
     "item"
     "last"
     "length of"
     "list"
     "lockable"
     "locked"
     "look"
     "male"
     "matching"
     "name"
     "narrate"
     "nested"
     "non-empty"
     "notice"
     "nowhere"
     "nth"
     "number"
     "number"
     "object"
     "on-seat"
     "open"
     "openable"
     "perform"
     "plural"
     "potable"
     "prevent"
     "print words"
     "proper"
     "pushable"
     "quit"
     "random from"
     "recursively leave non-vehicles"
     "refuse"
     "relation"
     "remove duplicates"
     "remove from"
     "repeat forever"
     "restart"
     "restore"
     "reverse"
     "rewrite"
     "room"
     "save undo"
     "save"
     "scope"
     "script off"
     "script on"
     "seat"
     "sharp"
     "shortest path"
     "singleton"
     "spell out"
     "split"
     "split"
     "stop"
     "supporter"
     "switchable"
     "take"
     "tick"
     "topic"
     "trace off"
     "trace on"
     "try"
     "uncountable"
     "understand"
     "undo"
     "unlikely due to room"
     "unlikely"
     "unlocked"
     "vehicle"
     "wearable"
     "word representing backspace"
     "word representing down"
     "word representing left"
     "word representing return"
     "word representing right"
     "word representing space"
     "word representing up"
     "word"
     "yesno"))

;; These are predicates that appear at the *end* of a ()

(defvar dialog-end-predicates
  '( "is closed"
     "is open"
     "is locked"
     "is unlocked"
     "is off"
     "is on"
     "is opaque"
     "is broken"
     "is transparent"
     "is in order"
     "is visited"
     "is handled"
     "is pristine"
     "is visited"
     "is unvisited"
     "is hidden"
     "is revealed"
     "is out of sight"
     "is already held"
     "is directly held"
     "is not here"
     "is out of reach"
     "is part of something"
     "is closed"
     "blocks passage"
     "is already"
     "provides light"
     "is fine where it is"
     "won't accept"
     "won't accept actor"
     "is fungible"))

;; These are predicates that appear *in* a () group

(defvar dialog-any-predicates
  '("="
    "<"
    ">"
    "divided"
    "has parent"
    "is one of"
    "minus"
    "modulo"
    "go"
    "one of"
    "contains one of"
    "recursively contains"
    "contains sublist"
    "has ancestor"
    "is in room"
    "is part of"
    "is worn by"
    "is recursively worn by"))

(defvar dialog-metadata
  '("error" "program entry point" "story author" "story blurb" "story ifid" "story noun" "story release" "story title" "removable word endings" "style class" "fungibility enabled" "serial number" "intro" "scoring enabled" "maximum score" "amusing enabled" "amusing" "game over" "game over status bar" "increase score by"))

(defvar dialog-actions
  '("take" "drop" "wear" "remove" "put" "close" "lock" "unlock" "open" "switch on" "switch off" "eat" "climb" "enter" "leave" "exits" "look" "examine" "search" "feel" "inventory" "read" "listen to" "taste" "smell" "kiss" "attack" "squeeze" "fix" "clean" "cut" "pull" "turn" "flush" "swim" "tie" "consult" "greet" "wait" "jump" "dance" "wave" "shrug" "exist" "sing" "fly" "think" "sleep" "pray" "curse" "waek up" "throw" "give" "show" "attack" "talk to" "talk" "shout to" "shout" "call" "ask" "tell" "greet" "stand" "sit" "go" "go to" "find" "use" "notify off" "notify on" "pronouns" "quit" "restart" "restore" "save" "score" "transcript off" "transcript on" "verbose" "version" "actions on" "actions off" "scope" "allrooms" "teleport" "purloin" "meminfo"))

(defvar dialog-participles
  '("switching off" "switching on" "eating" "entering" "failing to leave" "failing to look" "taking" "removing" "wearing" "putting" "dropping" "opening" "closing" "unlocking" "climbing" "entering" "leaving"))

(defvar dialog-control
  '("or" "if" "endif" "then" "else" "select" "elseif" "select" "stopping" "cycling" "at random"
    "purely at random" "then purely at random" "exhaust" "collect" "into" "collect words" "determine object" "from words" "matching all of" "stoppable" "now" "just" "global variable" "generate"
    ))

(defvar dialog-format
  '("div" "par" "status bar" "bold" "clear" "clear all" "fixed pitch" "italic" "line" "no space" "par" "roman" "space" "unstyle" "uppercase" "progress bar" "reverse" ))

(defvar dialog-tab-width 4 "Width of a tab for DIALOG mode")

(defvar dialog-font-lock-defaults
  `((
     ;; stuff between double quotes
       ("\"\\.\\*\\?" . font-lock-string-face)
       ("#\\sw+\\|\\$\\sw+\\|@\\sw+" . font-lock-variable-name-face)
       ("\\*\\|~\\|\\$" . font-lock-warning-face)
       ( ,(regexp-opt dialog-metadata 'words) . font-lock-keyword-face)
       ( ,(concat "\\((\\)\\(" (regexp-opt dialog-control 'words) "\\)") 2 font-lock-builtin-face)
       ( ,(concat "(" (regexp-opt dialog-format 'words) ")") . font-lock-type-face)
       ( ,(concat "(" (regexp-opt dialog-predicates 'words)) . font-lock-constant-face)
       ( ,(concat (regexp-opt dialog-end-predicates 'words) ")") . font-lock-constant-face)
       ( ,(regexp-opt dialog-any-predicates 'words) . font-lock-constant-face)
       (, (concat "\\(narrate\\s-\\)\\(" (regexp-opt dialog-participles 'words) "\\)") 2 font-lock-function-name-face)
       ( ,(concat "\\(\\[\\)\\(" (regexp-opt dialog-actions) "\\)") 2 font-lock-function-name-face)
       ("=\\|(\\|)\\||\\|\\[\\|\\]\\|{\\|}" . font-lock-constant-face)
       )))

(defun dialog-zero-indent ()
  "Determine if we are at a zero-indented line. A zero indented line is a line
   which begins with a # (e.g. #room), a ~ or a ( in the zero position."
  (or (bobp)
      (looking-at "%%")
      (and (looking-at "\\s-*$") (= (dialog-previous-indent) 0))
      (and (looking-at "\\s-*\\(#\\|~\\|(\\)")
           (not (looking-at "\\((if\\|(elseif\\|(collect\\|(endif\\|(into\\)"))
           (or
            (looking-at "\\s-*#")
            (looking-at "\\s-*([^\\*\n]*\\*")
            (save-excursion
              (progn
                (forward-line -1)
                (or (bobp)
                    (looking-at "^\\s-*$"))))))))

(defun dialog-increase-indent ()
  "Lines which should lead to an *increase* in the indentation of the following line."
  (looking-at "^\\s-*\\((if)\\|(else)\\|(elseif)\\|(collect\\|{\\s-*$\\|(exhaust)\\|(or)\\|(select)\\)"))

(defun dialog-decrease-indent ()
  "Lines which sould lead to a *decrease* in the indentation."
  (looking-at "^\\s-*\\((endif)\\|(else\\|(or\\|(into\\|}\\|(stopping\\|(cycling\\|(at random\\|(purely\\|(then purely\\)"))

;; Here are our rules
;; 1) If we are at the beginning of a file, or at the beginning of a block that starts with #,
;; or if the preceding line is blank, we indent to 0
;; 2) If the preceding line is an if, else, elseif, collect, then we increase the indent
;; 3) If the line is an endif or into statement then we decrease the indent
;; 4) Otherwise, we indent to the greater of (a) the indent of the previous line or (b) 1 width

(defun dialog-indent-line ()
  "Indent current line appropriately"
  (interactive)
  (save-excursion (beginning-of-line)
  (if (dialog-zero-indent)
      (indent-line-to 0)
    (if (dialog-decrease-indent)
        (indent-line-to (max (- (dialog-previous-indent) dialog-tab-width) dialog-tab-width))
      (indent-line-to (max (dialog-previous-indent) dialog-tab-width))))))

(defun dialog-previous-indent ()
  "Get the indentation of the previous line, if there is one.
Return that value, increased if need be to account for the
contents of the previous line, but never less than 0."
  (save-excursion
    (forward-line -1)
    (let ((previous-indent (current-indentation)))
        (if (dialog-increase-indent)
            (setq previous-indent (+ previous-indent dialog-tab-width)))
      (max previous-indent 0))))

(define-derived-mode dialog-mode fundamental-mode "dialog"
  "Dialog mode is a major mode for editing dialog files"
  (setq font-lock-defaults dialog-font-lock-defaults)
  (set (make-local-variable 'indent-line-function) 'dialog-indent-line)

  (when dialog-tab-width
    (setq tab-width dialog-tab-width))

  (setq comment-start "%%")
  (setq comment-end "")

  (modify-syntax-entry ?% ". 12" dialog-mode-syntax-table)
  (modify-syntax-entry ?\n ">" dialog-mode-syntax-table)
  (modify-syntax-entry ?# "w" dialog-mode-syntax-table)
  (modify-syntax-entry ?_ "w" dialog-mode-syntax-table)
  (modify-syntax-entry ?1 "w" dialog-mode-syntax-table)
  )

(provide 'dialog-mode)
