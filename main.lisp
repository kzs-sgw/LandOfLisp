(defun main ()
  (sdl:with-init ()
    (sdl:window 640 480 :title-caption "TesT") ;create window
    (setf (sdl:frame-rate) 60)

    (sdl:upate-display)

    ;;‚¢‚×‚ñ‚Æˆ—
    (sdl:with-events ()
    
