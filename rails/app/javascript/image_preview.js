document.addEventListener("turbo:load", () => {
  if (isProfilePage()) {
    setupAvatarPreview();
  }
});

function isProfilePage() {
  const pageTitle = document.querySelector('title').textContent;
  return pageTitle.includes("プロフィール");
}

function setupAvatarPreview() {
  const fileInput = document.querySelector('input[type="file"]');
  const preview = document.getElementById('avatar-preview');
  const defaultImageSrc = "<%= asset_path('default_avatar.png') %>";

  const initialImageSrc = preview.src || defaultImageSrc;

  if (fileInput) {
    fileInput.addEventListener('change', (event) => {
      handleFileChange(event, preview, initialImageSrc);
    });
  }
}

function handleFileChange(event, preview, initialImageSrc) {
  const file = event.target.files[0];
  const reader = new FileReader();

  reader.onload = (e) => {
    preview.src = e.target.result;
  };

  if (file) {
    reader.readAsDataURL(file);
  } else {
    preview.src = initialImageSrc;
  }
}