# Window Transparency Toggle Script

- This is the code I stole. Dont mind if I do.
![Transparency Toggle](./screenshot.PNG)

## Features
- **Toggle Window Transparency**: Easily activate or deactivate the transparency effect on any window.
- **Adjust Transparency in Real-Time**: Control the opacity of the active window using your scroll wheel.
- **Tooltip Feedback**: Displays the current transparency level in a tooltip near your mouse cursor.
- **Full Transparency Control**: Adjust window transparency from fully opaque (255) to completely transparent (0).

## Controls
- **Toggle Transparency**:  
  `CTRL + WIN + ALT + Right Mouse Button (RMB)`  
  Activates or deactivates window transparency for the currently focused window. 

- **Decrease Transparency**:  
  `CTRL + WIN + ALT + Scroll Down`  
  Decreases the transparency by 10 units (down to 0, which is fully transparent).

- **Increase Transparency**:  
  `CTRL + WIN + ALT + Scroll Up`  
  Increases the transparency by 10 units (up to 255, which is fully opaque).

## Customization

- **Transparency Range**:  
  The transparency level starts at 200 (semi-transparent). 
- **Tooltip Duration**:  
  By default, the tooltip will disappear after 1 second.
  You can adjust this duration by modifying the `titleChangeDuration`.