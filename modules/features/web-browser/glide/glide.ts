glide.keymaps.set("normal", "o", "commandline_show tab ");
glide.keymaps.set("normal", "O", "commandline_show tab_new ");

glide.keymaps.set("command", "<C-n>", "commandline_focus_next");
glide.keymaps.set("command", "<C-j>", "commandline_focus_next");
glide.keymaps.set("command", "<C-p>", "commandline_focus_back");
glide.keymaps.set("command", "<C-k>", "commandline_focus_back");

glide.keymaps.set("normal", "<A-h>", "go_previous");
glide.keymaps.set("normal", "<A-l>", "go_next");
glide.keymaps.set("normal", "H", "tab_prev");
glide.keymaps.set("normal", "L", "tab_next");

glide.keymaps.set("normal", "bd", "tab_close");
glide.keymaps.set("normal", "bo", async () => {
  const tabs = await glide.tabs.query({ active: false, currentWindow: true });
  const tabIds = tabs.map(t => t.id || null).filter(id => id !== null);
  await browser.tabs.remove(tabIds);
});

glide.keymaps.set(["normal", "insert"], "<C-h>", "back");
glide.keymaps.set(["normal", "insert"], "<C-l>", "forward");

glide.o.hint_size = "18px";

glide.include("extensions.glide.ts");
