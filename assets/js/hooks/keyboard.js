import { getAttributeOrThrow, parseBoolean } from "../lib/attribute";
import { cancelEvent, isEditableElement } from "../lib/utils";

const Keyboard = {
  mounted() {
    this.props = this.getProps();

    this._handleDocumentKeyDown = this.handleDocumentKeyDown.bind(this);
    this._handleDocumentKeyUp = this.handleDocumentKeyUp.bind(this);
    this._handleDocumentFocus = this.handleDocumentFocus.bind(this);

    window.addEventListener("keydown", this._handleDocumentKeyDown, true);
    window.addEventListener("keyup", this._handleDocumentKeyUp, true);
    window.addEventListener("focus", this._handleDocumentFocus, true);
  },

  updated() {
    this.props = this.getProps();
  },

  destroyed() {
    window.removeEventListener("keydown", this._handleDocumentKeyDown, true);
    window.removeEventListener("keyup", this._handleDocumentKeyUp, true);
    window.removeEventListener("focus", this._handleDocumentFocus, true);
  },

  getProps() {
    return {
      isKeydownEnabled: getAttributeOrThrow(
        this.el,
        "data-keydown-enabled",
        parseBoolean
      ),
      isKeyupEnabled: getAttributeOrThrow(
        this.el,
        "data-keyup-enabled",
        parseBoolean
      ),
      target: getAttributeOrThrow(this.el, "data-target"),
    };
  },

  handleDocumentKeyDown(event) {
    if (this.keyboardEnabled()) {
      cancelEvent(event);
    }

    if (this.props.isKeydownEnabled) {
      if (event.repeat) {
        return;
      }

      const { key } = event;
      this.pushEventTo(this.props.target, "keydown", { key });
    }
  },

  handleDocumentKeyUp(event) {
    if (this.keyboardEnabled()) {
      cancelEvent(event);
    }

    if (this.props.isKeyupEnabled) {
      const { key } = event;
      this.pushEventTo(this.props.target, "keyup", { key });
    }
  },

  handleDocumentFocus(event) {
    if (this.props.isKeydownEnabled && isEditableElement(event.target)) {
      this.pushEventTo(this.props.target, "disable_keyboard", {});
    }
  },

  keyboardEnabled() {
    return this.props.isKeydownEnabled || this.props.isKeyupEnabled;
  },
};

export default Keyboard;
