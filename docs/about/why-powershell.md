# Why Choose PowerShell?

## Primary Considerations

Arguments can be made for or against a number of languages, comparing strengths and reliability, but for the context of working with an RMM, the calculus comes down to two factors
### Representation

Most MSPs I've worked with have supported 90-95% Windows endpoints, and that's being generous. Linux may power the internet, but Windows powers SMB. 

In a Microsoft-centric landscape, PowerShell is the tool that makes sense for endpoint management.
### Presence

`So what if all of the endpoints are Windows? Python runs on Windows. Go runs on Windows. Why PowerShell?`

Because it's there. It's one less dependency. In a regulated environment, it's one less control. 

When you assume management of a Windows endpoint, you can safely assume it's already got PowerShell. 

## Benefits

Since we know PowerShell is the only reasonable choice, we might as well embrace some of the things it handles well. 

### It's Object Oriented

Unlike older interpreters like DOS, PowerShell can work with objects, arrays, hash tables and the like when passing data between commands or APIs. This helps simplify script writing and allows for more dynamic interaction. 
### It's Built on .Net

And so is Windows. Just about anything you can do to a Windows computer, you can do with .Net. 

And if you can do it with .Net, you can do it with PowerShell

### It's Cross-Platform

Yes, you can run PowerShell on MacOS and Linux. 

No, it's not installed natively. 

Yes, that goes against the dependency constraint I discussed earlier. 

But it is an option. 

### Simple Support for CSV/JSON

PowerShell has native options for interacting with CSV and JSON payloads, making transforms between object and file/API easy without needing external modules.