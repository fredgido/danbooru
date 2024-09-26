import Cropper from "cropperjs";

export default class ProfilePictureCropperComponent {
  static initialize() {
    $(".profile-picture-cropper-component").toArray().forEach(element => {
      new ProfilePictureCropperComponent(element);
    });
  }

  constructor(element) {
    this.$component = $(element);
    this.$container = this.$component.find(".media-asset-container");
    this.$image = this.$component.find(".media-asset-image");
    this.$button = $("#set-profile-picture");

    this.$image.height = this.$image.offsetHeight;
    this.$image.width = this.$image.offsetWidth;

    if (this.$image.length) {
      this.cropper = new Cropper(this.$image.get(0), {
        checkCrossOrigin: false,
        movable: false,
        rotatable: false,
        scalable: false,
        zoomOnWheel: false,
        aspectRatio: 1,
        autoCrop: true,
        viewMode: 0,
        preview: "#selection-preview",
        ready: (_e) => {
          let form = $("#submit-profile-picture-form");
          let x = form.find(".left").val();
          let y = form.find(".top").val();
          let width = form.find(".width").val();
          let height = form.find(".height").val();
          // doesn't work, dunno why
          this.cropper.setCropBoxData({ x, y, width, height });
        }
      });
      this.$button.on("click", () => this.sendCroppedImage());
    } else {
      this.$button.disabled = true;
    }
  }

  sendCroppedImage() {
    if (this.cropper) {
      let { x, y, width, height } = this.cropper.getData();
      let form = $("#submit-profile-picture-form");
      form.find(".left").val(x);
      form.find(".top").val(y);
      form.find(".width").val(width);
      form.find(".height").val(height);
      form.trigger("submit");
    } else {
      console.warn("this.cropper is undefined");
    }
  }
}

$(ProfilePictureCropperComponent.initialize);
