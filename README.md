# Edubooster Exam Board

A subscription-based examination paper library for learners, teachers, schools, and educational institutions.

The project is designed to be developed in **GitHub Codespaces**. You do not need to install XAMPP, PHP, Composer, MySQL, or Apache on your personal computer.

## Start development

1. Open this repository on GitHub.
2. Select **Code → Codespaces → Create codespace on main**.
3. Wait for the Codespace to finish its first-time setup. The development container installs PHP 8.4, Composer, Node.js, and the required PHP extensions.
4. The bootstrap script creates the Laravel application, configures SQLite for development, runs the initial migrations, builds the frontend assets, and starts the Laravel server.
5. Open the forwarded **Edubooster Exam Board** port (8000) to view the application.

The application source is created inside the Codespace and committed to this repository. No local PHP environment is required.

## Useful commands

```bash
# Start the Laravel server manually if needed
php artisan serve --host=0.0.0.0 --port=8000

# Run database migrations
php artisan migrate

# Build frontend assets
npm run build

# Start Vite during frontend development
npm run dev -- --host=0.0.0.0

# Run automated tests
php artisan test
```

## Product scope

The platform will provide:

- Public browsing of published examinations by education level, class, subject, academic year, term, and examination type.
- Protected question papers and marking guides for eligible subscribers.
- Configurable weekly, monthly, termly, annual, and institutional subscription plans.
- MTN Mobile Money payment initiation, provider-status verification, callback handling, and scheduled reconciliation.
- Subscriber-specific PDF downloads with identity watermarking and verification codes.
- Download history, audit trails, and administrative reporting.
- Role-based access for Super Administrators, Content Managers, Subscribers, and Guests.

## Security principles

- Original examination documents must be stored outside the public web root or in private object storage.
- Never expose private document storage paths as public download URLs.
- Check subscription eligibility on every protected download request.
- Activate subscriptions only after a payment is verified as successful.
- Keep payment credentials and application secrets in environment variables or a managed secret store. Never commit real credentials to Git.
- Use SQLite only for initial Codespaces development. Production database and payment credentials must be configured separately before deployment.

## Development database

The Codespaces bootstrap configures a local SQLite database at `database/database.sqlite`. This is for development and testing only; it does not configure or modify a production database.
