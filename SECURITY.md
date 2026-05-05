# Security Policy

## Supported Versions

We take security seriously and provide security updates for the following versions of Tally:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x (Beta) | ✅ Yes |
| < 0.1.0 | ❌ No |

**Note:** As Tally is currently in beta (0.1.x), we are actively working on security improvements and will address vulnerabilities promptly.

## Reporting a Vulnerability

We appreciate your help in keeping Tally secure. If you discover a security vulnerability, please follow these steps:

### How to Report

**Please DO NOT create a public GitHub issue for security vulnerabilities.**

Instead, report security issues privately by:

1. **Email**: Send details to [YOUR_EMAIL@example.com] with the subject line "Tally Security Vulnerability"
2. **GitHub Security Advisory**: Use GitHub's [private vulnerability reporting](https://github.com/YOUR_USERNAME/tally/security/advisories/new)

### What to Include

Please provide as much information as possible:

- Type of vulnerability (e.g., authentication bypass, SQL injection, XSS)
- Affected component(s) and version(s)
- Step-by-step instructions to reproduce the issue
- Proof of concept or exploit code (if available)
- Potential impact of the vulnerability
- Suggested fix (if you have one)

### Response Timeline

- **Initial Response**: Within 48 hours of receiving your report
- **Status Update**: We'll provide updates every 5-7 days on our progress
- **Resolution**: We aim to resolve critical vulnerabilities within 30 days

### What to Expect

**If the vulnerability is accepted:**
- We'll work on a fix and keep you updated on progress
- You'll be credited in the security advisory (unless you prefer to remain anonymous)
- We'll coordinate with you on the disclosure timeline
- A security patch will be released as soon as possible

**If the vulnerability is declined:**
- We'll provide a clear explanation of why it's not considered a security issue
- We may suggest alternative reporting channels if it's a bug rather than a security issue

## Security Best Practices

When using Tally, please follow these security guidelines:

### For Users

- **Keep your credentials secure**: Never share your Supabase credentials or API keys
- **Use strong passwords**: Enable strong authentication for your Supabase account
- **Keep the app updated**: Always use the latest version to benefit from security patches
- **Review permissions**: Only grant necessary permissions to the app

### For Developers

- **Environment variables**: Never commit `.env` files or credentials to version control
- **Supabase security**: 
  - Use Row Level Security (RLS) policies
  - Keep your `SUPABASE_ANON_KEY` secure
  - Never expose your `SUPABASE_SERVICE_KEY` in client code
- **Dependencies**: Regularly update dependencies to patch known vulnerabilities
- **Code review**: Review all code changes for potential security issues
- **Input validation**: Always validate and sanitize user input

## Known Security Considerations

### Current Implementation

- **Authentication**: Handled by Supabase Auth
- **Data Storage**: All data stored in Supabase with RLS policies
- **API Keys**: Stored in `.env` file (not committed to repository)

### Planned Security Enhancements

As we move toward version 1.0, we plan to implement:

- Enhanced input validation and sanitization
- Additional security audits
- Automated security scanning in CI/CD
- More comprehensive RLS policies

## Security Updates

Security updates will be announced through:

- GitHub Security Advisories
- Release notes in the [Releases](https://github.com/YOUR_USERNAME/tally/releases) page
- Updates to this SECURITY.md file

## Scope

This security policy applies to:

- The Tally application codebase
- Official releases and distributions
- Documentation and setup instructions

This policy does NOT cover:

- Third-party dependencies (report to their respective maintainers)
- Self-hosted Supabase instances (your responsibility to secure)
- Forks or modified versions of Tally

## Questions?

If you have questions about this security policy or general security concerns (not vulnerabilities), please:

- Open a [GitHub Discussion](https://github.com/YOUR_USERNAME/tally/discussions)
- Contact us at [YOUR_EMAIL@example.com]

## Acknowledgments

We appreciate the security researchers and users who help keep Tally secure. Contributors who responsibly disclose vulnerabilities will be acknowledged in our security advisories (with their permission).

---

**Last Updated**: May 2026
