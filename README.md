# Redundancy Hub

A progressive web app for managing a redundancy: the package (gross vs received), a jobs tracker, a candidate pack and useful links.

Data is always saved on the device. With cloud sync set up, it is also saved to your own Supabase database, so the same data appears on your phone and laptop.

## Files to deploy

```
index.html
config.js
manifest.webmanifest
sw.js
icons/icon-192.png
icons/icon-512.png
icons/maskable-512.png
```

`supabase-setup.sql` is run once in Supabase and doesn't need deploying. `app-body.html` is only the preview version.

## 1. Create the database (about 10 minutes, free)

1. Sign up at https://supabase.com and choose **New project**.
   - Name: `redundancy-hub`
   - Region: **Sydney (ap-southeast-2)**, so your data stays in Australia
   - Set a database password and store it in your password manager. The app doesn't use it.
2. When the project is ready, open **SQL Editor → New query**. Paste in everything from `supabase-setup.sql` and select **Run**. This creates the `hub_state` table and the rules that let only your account read your data.
3. Open **Project Settings → API**, or select the **Connect** button. Copy:
   - the **Project URL** (`https://xxxx.supabase.co`)
   - the **publishable** key (older projects call it the **anon public** key)

   Don't use the `service_role` or secret key.
4. Open `config.js`, replace the two placeholder values with what you copied, and save the file.

## 2. Deploy

### GitHub Pages
1. Create a repository, e.g. `redundancy-hub`, and upload the files listed above to its root.
2. Go to **Settings → Pages**. Under Source, choose "Deploy from a branch", then branch `main` and folder `/ (root)`.
3. The app goes live at `https://<username>.github.io/redundancy-hub/`.

### Vercel
Import the repository and accept the defaults. There's no build step.

## 3. Point Supabase at your site

In Supabase, go to **Authentication → URL Configuration** and set **Site URL** to the address of your deployed app. Supabase uses it for links in the confirmation email.

## 4. Create your account and lock it down

1. Open the deployed app and go to **About → Cloud sync**. Enter your email and a password, then select **Create account**.
2. Open the confirmation email, then go back to the app and select **Sign in**.

   Signing in uploads what's on that device. If the device only has the example data, select **Clear examples** first.
3. In Supabase, go to **Authentication → Sign In / Providers** and turn off **Allow new users to sign up**. That stops anyone else creating an account on your database.
4. Sign in with the same email and password on your other devices.

## How sync works

- Every change saves on the device straight away, then uploads to the database a second later.
- When you open the app or switch back to it, it downloads any newer changes made on another device.
- Offline, changes queue on the device and upload when you reconnect. The badge at top right shows the status: Saved, Syncing…, Offline or Sign in to sync.
- If two devices are edited at once, the most recent save wins. Your data is stored as one record per user. You can view it in Supabase under **Table Editor → hub_state**.
- Free Supabase projects pause after a week with no activity. If that happens, open the Supabase dashboard and select **Restore project**. Your data is kept while it's paused.

## Install as an app

- iPhone or iPad: open the site in Safari, then choose **Share → Add to Home Screen**. Then sign in from the installed app, because it keeps its own storage separate from Safari.
- Android, or desktop Chrome or Edge: use the **Install** icon in the address bar or the browser menu.

When you change `index.html`, bump `CACHE` in `sw.js` (for example to `redundancy-hub-v3`) so installed copies pick up the update.

## Notes

- The tax-free limits use the ATO's 2026–27 figures: $13,598 plus $6,801 per completed year of service. Update the `ATO` constant in `index.html` each July.
- The app gives general information only. It isn't financial or tax advice.
