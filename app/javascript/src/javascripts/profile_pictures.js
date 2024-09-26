import "jquery-ui/ui/widgets/draggable";

import CurrentUser from "./current_user";
import Utility, { clamp } from "./utility";

class ProfilePicture {
  static initializeAll() {
    // $("img.media-asset-image").draggable();
  }

  constructor() {
    // $("img.media-asset-image").draggable();
  }
}

$(() => {
  ProfilePicture.initializeAll();
});

export default ProfilePicture;
