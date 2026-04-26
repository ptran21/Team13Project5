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

// --- Navigation & Modal Controls ---

function navigateHome() {
  document.getElementById("category-view").classList.add("hidden");
  document.getElementById("home-view").classList.remove("hidden");
}

function closeModal() {
  document.getElementById("item-modal").classList.add("hidden");
}
