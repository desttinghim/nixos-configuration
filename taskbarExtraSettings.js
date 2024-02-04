panelIds.forEach((panel) => {
  panel = panelById(panel);
  if (!panel) return;
  panel.widgetIds.forEach((appletWidget) => {
    appletWidget = panel.widgetById(appletWidget);
    if (appletWidget.type === "org.kde.plasma.kickoff") {
      appletWidget.globalShortcut = "Meta+Shift+D";
    }
  })
});
