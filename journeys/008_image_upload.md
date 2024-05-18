
# Image Upload

## Summary
Users need to be able to upload a profile images.

I'd like:
- Image upload to perform quickly in the US and Europe
- Storage to be relatively cheap or free
- Optimization of the image to be performed on the server
- A CDN if possible to serve the image


## Options
https://uploadcare.com/
...there must have been more but I liked uploadcare's API and free trier enough to just go with it.

## Image picking and cropping 
For now I've implemented using UIImagePicker that offers croping functionaltiy, but in the future we'll have to add our own because this functionality is being deprecated for the photo picking side (seems the camera capture side is remaining). 

### SwiftUI Interactive Cropping
* https://www.youtube.com/watch?v=1Fz86eQjxus
* https://github.com/guoyingtao/Mantis
