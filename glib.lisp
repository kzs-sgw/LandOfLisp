;; Require libralies
(require 'asdf)
(require 'cl-opengl)
(require 'cl-glut)
(require 'cl-glu)

;; Parameters
(defvar *width* 500)
(defvar *height* 500)

;; USER FUNCTIONS
(defun user-display () ())
(defun user-init () ())
(defun user-idle () ())

;; Derived window class
(defclass main-window (glut:window) ()
    (:default-initargs :title "opengl test" :mode '(:double :rgb :depth) :width *width* :height *height*))

;; glut:display
;; Draw.
(defmethod glut:display ((window main-window))
    ;; Clear buffer
    (gl:clear :color-buffer :depth-buffer)

    ;; Draw shape
    ;;(glDisable GL_CULL_FACE)  
    (gl:shade-model :flat)
    (gl:normal 0 0 1)

    ;; user display process
    (user-display)

    ;; Swap buffer
    (glut:swap-buffers))

;; glut:idle
;; Application idle.
(defmethod glut:idle ((window main-window))
    ;; user idling process
    (user-idle)
    (glut:post-redisplay))

;; glut:reshape
(defmethod glut:reshape ((w main-window) width height)
    (gl:viewport 0 0 width height)
    (gl:load-identity)
    (glu:ortho-2d 0.0 *width* *height* 0.0))

;; glut-display
;; Draw.
(defmethod glut:display-window :before ((window main-window)) )

;; main
;; Main function (Program entry point).
(defun main ()
    ;; user initalization process
    (user-init)
    ;;(glut:special-func #'key-special)
    (glut:display-window (make-instance 'main-window)))
