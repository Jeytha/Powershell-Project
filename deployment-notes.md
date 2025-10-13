# Deployment Notes

- Run `deploy.ps1` from the repository `scripts` folder with an elevated PowerShell session.
- After deployment, review `C:\Scripts` and edit parameters at the top of each script to match your environment.
- Monitor logs in `C:\Logs` and firewall log at `C:\Windows\System32\LogFiles\Firewall\pfirewall.log`
- For production use, replace simple log writing with forwarding to SIEM (Splunk, Azure Sentinel, Elastic, etc.).
