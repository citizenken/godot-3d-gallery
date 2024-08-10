# 3D Gallery

3D Gallery is a Godot 4+ plugin that makes viewing imported 3D models easier. Rather than clicking on each model to view it in the import popup, or adding it to a scene, 3D Gallery allows you to quickly scan through your filesystem previewing each model. This comes in handy when you have a large number of models and want to flip through them quickly (ex. after purchasing an asset library).

3D will walk your project directory, looking for any Godot-supported 3D model formats (`.blend`, `.obj`, `.glb`, `.gltf`, `.fbx`, `.dae`), and present them in a filetree format. Then, you can click or use your arrow keys to easily preview each model.

If you navigate away from the 3D Gallery tab, it holds your place so when you resume, you'll still have the same model selected.


## Installation
1. Clone the repo
2. Copy `addons/3DGallery` to your project's `addon` folder
3. Enable the plugin in project settings

Alternatively, install it from the AssetLib in the Godot editor.

## Controls
* Left mouse click and drag to rotate the camera around the model.
* Right mouse click and drag to rotate the model on the Y-axis,
  hold shift to rotate on the Z-axis
* Up/down/left/right arrows to navigate through the file tree.
