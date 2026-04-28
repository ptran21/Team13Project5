// Data state
let categoriesData = [];
let listingsData = [];

// The 5 mandatory sections mapped to their expected IDs
const MAIN_SECTIONS = [
  { id: 1, name: "For Sale" },
  { id: 2, name: "Housing" },
  { id: 3, name: "Services" },
  { id: 4, name: "Jobs" },
  { id: 5, name: "Community" },
];

document.addEventListener("DOMContentLoaded", () => {
  fetchCategories();
  fetchListings();
});

// --- API Calls ---

async function fetchCategories() {
  try {
    const response = await fetch("/api/categories");
    const data = await response.json();
    categoriesData = data.categories;
    renderSections();
  } catch (error) {
    console.error("Error fetching categories:", error);
  }
}

async function fetchListings() {
  try {
    const response = await fetch("/api/listings");
    const data = await response.json();
    listingsData = data.items;
  } catch (error) {
    console.error("Error fetching listings:", error);
  }
}

// --- Rendering ---

function renderSections() {
  const container = document.getElementById("sections-container");
  container.innerHTML = "";

  MAIN_SECTIONS.forEach((section) => {
    // Filter categories that belong to this section
    const sectionCategories = categoriesData.filter(
      (c) => c.section_id === section.id || c.section_name === section.name,
    );

    const sectionEl = document.createElement("div");
    sectionEl.className = "section-card";

    let html = `<h3>${section.name}</h3><ul class="category-list">`;
    sectionCategories.forEach((cat) => {
      html += `<li onclick="showCategory(${cat.id}, '${cat.name}')">${cat.name}</li>`;
    });
    html += `</ul>`;

    sectionEl.innerHTML = html;
    container.appendChild(sectionEl);
  });
}

function showCategory(categoryId, categoryName) {
  document.getElementById("home-view").classList.add("hidden");
  document.getElementById("category-view").classList.remove("hidden");
  document.getElementById("category-title").textContent = categoryName;

  const container = document.getElementById("items-container");
  container.innerHTML = "";

  // Filter items for this specific category
  const items = listingsData.filter((item) => item.category_id === categoryId);

  if (items.length === 0) {
    container.innerHTML = "<p>No items found in this category.</p>";
    return;
  }

  items.forEach((item) => {
    const itemCard = document.createElement("div");
    itemCard.className = "item-card";
    itemCard.innerHTML = `
      <h4>${item.title}</h4>
      <p class="price">$${item.price}</p>
      <p class="location">${item.city}</p>
      <button onclick="showItemDetails(${item.id})">View Details</button>
    `;
    container.appendChild(itemCard);
  });
}

function showItemDetails(itemId) {
  const item = listingsData.find((i) => i.id === itemId);
  if (!item) return;

  document.getElementById("modal-title").textContent = item.title;
  document.getElementById("modal-price").textContent = item.price;
  document.getElementById("modal-condition").textContent =
    item.condition_status;
  document.getElementById("modal-city").textContent = item.city;
  document.getElementById("modal-seller").textContent =
    item.seller_username || "Anonymous";
  document.getElementById("modal-phone").textContent = item.phone;
  document.getElementById("modal-description").textContent = item.description;

  document.getElementById("item-modal").classList.remove("hidden");
}


function showCreateListing() {
  document.getElementById("home-view").classList.add("hidden");
  document.getElementById("category-view").classList.add("hidden");
  document.getElementById("create-listing-view").classList.remove("hidden");

  populateCategoryDropdown();
}

function populateCategoryDropdown() {
  const categorySelect = document.getElementById("listing-category");

  categorySelect.innerHTML = `<option value="">Select a category</option>`;

  categoriesData.forEach((cat) => {
    const option = document.createElement("option");
    option.value = cat.id;
    option.textContent = `${cat.section_name || "Section"} - ${cat.name}`;
    categorySelect.appendChild(option);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("create-listing-form");

  if (form) {
    form.addEventListener("submit", submitListingForm);
  }
});

function clearFormErrors() {
  const errorIds = [
    "title-error",
    "category-error",
    "price-error",
    "city-error",
    "phone-error",
    "condition-error",
    "description-error",
  ];

  errorIds.forEach((id) => {
    document.getElementById(id).textContent = "";
  });

  document.getElementById("form-message").textContent = "";
}

function validateListingForm() {
  clearFormErrors();

  let isValid = true;

  const title = document.getElementById("listing-title").value.trim();
  const categoryId = document.getElementById("listing-category").value;
  const price = document.getElementById("listing-price").value;
  const city = document.getElementById("listing-city").value.trim();
  const phone = document.getElementById("listing-phone").value.trim();
  const condition = document.getElementById("listing-condition").value;
  const description = document.getElementById("listing-description").value.trim();

  if (!title) {
    document.getElementById("title-error").textContent = "Title is required.";
    isValid = false;
  }

  if (!categoryId) {
    document.getElementById("category-error").textContent = "Category is required.";
    isValid = false;
  }

  if (price && Number(price) < 0) {
    document.getElementById("price-error").textContent = "Price cannot be negative.";
    isValid = false;
  }

  if (!city) {
    document.getElementById("city-error").textContent = "City is required.";
    isValid = false;
  }

  if (!phone) {
    document.getElementById("phone-error").textContent = "Phone is required.";
    isValid = false;
  }

  if (!condition) {
    document.getElementById("condition-error").textContent = "Condition is required.";
    isValid = false;
  }

  if (!description) {
    document.getElementById("description-error").textContent = "Description is required.";
    isValid = false;
  }

  return isValid;
}

async function submitListingForm(event) {
  event.preventDefault();

  const isValid = validateListingForm();

  if (!isValid) {
    return;
  }

  const token = localStorage.getItem("token");

  if (!token) {
    document.getElementById("form-message").textContent =
      "You must be logged in to create a listing.";
    document.getElementById("form-message").className = "error-message";
    return;
  }

  const formData = {
    title: document.getElementById("listing-title").value.trim(),
    category_id: Number(document.getElementById("listing-category").value),
    price: document.getElementById("listing-price").value
      ? Number(document.getElementById("listing-price").value)
      : null,
    description: document.getElementById("listing-description").value.trim(),
    city: document.getElementById("listing-city").value.trim(),
    phone: document.getElementById("listing-phone").value.trim(),
    condition_status: document.getElementById("listing-condition").value,
  };

  try {
    const response = await fetch("/api/listings", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(formData),
    });

    const data = await response.json();

    if (!response.ok) {
      document.getElementById("form-message").textContent =
        data.error || "Listing could not be created.";
      document.getElementById("form-message").className = "error-message";
      return;
    }

    document.getElementById("form-message").textContent =
      "Listing created successfully!";
    document.getElementById("form-message").className = "success-message";

    document.getElementById("create-listing-form").reset();

    await fetchListings();
  } catch (error) {
    console.error("Create listing error:", error);
    document.getElementById("form-message").textContent =
      "Server error. Please try again.";
    document.getElementById("form-message").className = "error-message";
  }
}

// --- Navigation & Modal Controls ---

function navigateHome() {
  document.getElementById("category-view").classList.add("hidden");
  document.getElementById("create-listing-view").classList.add("hidden");
  document.getElementById("home-view").classList.remove("hidden");
}

function closeModal() {
  document.getElementById("item-modal").classList.add("hidden");
}
