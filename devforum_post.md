<img style="border-radius: 20px;" src=https://raw.githubusercontent.com/Inctus/AtomicStore/main/docs/Images/banner.png>

---------------

<div align=center> 

<h1>AtomicStore</h1>
<code>
 Control Your Data   

 [Source](https://meta.discourse.org/t/linkedin-oauth2-plugin/46818) | [Documentation](https://meta.discourse.org/t/discourse-moderation-guide/63116) | [Changelog](https://meta.discourse.org/t/how-to-contribute-to-discourse/53797)

</code>

<img style="float: right;" width=50px; src="https://raw.githubusercontent.com/Inctus/AtomicStore/main/docs/Images/logo.png">

</div>

--------------------

## Why AtomicStore?
If, like me, you remember the days back before Data Persistence Modules became mainstream, you will doubtless remember the painstaking effort that went into creating and maintaining your own solution. Despite this effort, it **did** offer you an unprecedented level of control over the handling of your data, allowing you to do what you want with it, without having to deal with unnecessary layers of abstraction or obfuscation and loss of control over features you deem important.

My solution? Create a lower level DataStore wrapper, capable of retaining all of the same controls that you would get from interfacing with a DataStore directly, but abstracting all of the boilerplate code, allowing you a cleaner, more elegant interface with your data. 

This control allows you to manage your DataStore budgets more efficiently for your game, and for more precise control over your data's structure, which is especially useful when you're trying to emulate a relational database on ROBLOX, something, which due to a lack of atomicity, is notoriously difficult.  