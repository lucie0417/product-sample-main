"use strict";

const storageKey = "daily-todos-v1";
const form = document.querySelector("#todo-form");
const input = document.querySelector("#todo-input");
const list = document.querySelector("#todo-list");
const emptyState = document.querySelector("#empty-state");
const remaining = document.querySelector("#remaining");
const storageMessage = document.querySelector("#storage-message");

function showStorageMessage(message) {
  storageMessage.textContent = message;
  storageMessage.hidden = false;
}

// 驗證儲存資料，避免損壞的資料影響頁面操作。
function loadTodos() {
  try {
    const saved = JSON.parse(localStorage.getItem(storageKey) || "[]");
    if (!Array.isArray(saved)) throw new Error("資料格式不正確");
    return saved.filter(todo => todo && typeof todo.text === "string" &&
      todo.text.trim() && typeof todo.completed === "boolean");
  } catch {
    showStorageMessage("無法讀取先前的清單。你仍然可以新增待辦事項。");
    return [];
  }
}

let todos = loadTodos();

function saveTodos() {
  try {
    localStorage.setItem(storageKey, JSON.stringify(todos));
    storageMessage.hidden = true;
  } catch {
    showStorageMessage("目前無法儲存資料，關閉或重新整理頁面後可能遺失清單。");
  }
}

function render() {
  list.replaceChildren();
  todos.forEach((todo, index) => {
    const item = document.createElement("li");
    item.className = `todo-item${todo.completed ? " completed" : ""}`;
    const label = document.createElement("label");
    label.className = "todo-label";
    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.checked = todo.completed;
    const text = document.createElement("span");
    text.className = "todo-text";
    // 使用文字節點呈現使用者輸入，避免將內容解讀為 HTML。
    text.textContent = todo.text;
    checkbox.addEventListener("change", () => {
      todo.completed = checkbox.checked;
      item.classList.toggle("completed", todo.completed);
      saveTodos();
      updateSummary();
    });
    label.append(checkbox, text);
    const deleteButton = document.createElement("button");
    deleteButton.type = "button";
    deleteButton.className = "delete-button";
    deleteButton.textContent = "刪除";
    deleteButton.setAttribute("aria-label", `刪除 ${todo.text}`);
    deleteButton.addEventListener("click", () => {
      todos.splice(index, 1);
      saveTodos();
      render();
      const nextButton = list.children[Math.min(index, todos.length - 1)]?.querySelector("button");
      (nextButton || input).focus();
    });
    item.append(label, deleteButton);
    list.append(item);
  });
  updateSummary();
}

function updateSummary() {
  emptyState.hidden = todos.length > 0;
  remaining.textContent = `未完成:${todos.filter(todo => !todo.completed).length} 項`;
}

form.addEventListener("submit", event => {
  event.preventDefault();
  const text = input.value.trim();
  if (!text) {
    input.value = "";
    input.focus();
    return;
  }
  todos.push({ text, completed: false });
  saveTodos();
  render();
  input.value = "";
  input.focus();
});

render();
