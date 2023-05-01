export function getAttributeOrThrow(element, attr, transform = null) {
  if (!element.hasAttribute(attr)) {
    throw new Error(
      `Missing attribute '${attr}' on element <${element.tagName}:${element.id}>`
    );
  }

  const value = element.getAttribute(attr);

  return transform ? transform(value) : value;
}

export function parseBoolean(value) {
  if (value === "true") {
    return true;
  }

  if (value === "false") {
    return false;
  }

  throw new Error(
    `Invalid boolean attribute ${value}, should be either "true" or "false"`
  );
}
