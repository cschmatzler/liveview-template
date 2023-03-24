export function isEditableElement(element) {
  return (
    element.matches && element.matches("input, textarea, [contenteditable]")
  );
}

export function cancelEvent(event) {
  event.preventDefault();
  event.stopPropagation();
}
