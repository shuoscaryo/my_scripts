#include <iostream>
#include <fstream>

#define SRC_VAR "SRC :="

bool is_comment(const std::string& line)
{
	for (size_t i = 0; i < line.length(); i++)
	{
		if (line[i] == '#')
			return true;
		if (line[i] != ' ' && line[i] != '\t')
			return false;
	}
	return false;
}

void erase_lines(std::string& content, size_t pos)
{
	int last_line = 0;
	while (!last_line)
	{
		size_t end = content.find("\n", pos);
		std::string line;
		if (end == std::string::npos)
			line = content.substr(pos, content.length() - pos);
		else
			line = content.substr(pos, end - pos + 1);
		if(is_comment(line))
			break;
		if (line.find("\\") == std::string::npos)
			last_line = 1;
		content.erase(pos, end - pos + 1);
	}
}

int main(int argc, char** args)
{
	//open Makefile
	std::fstream file("Makefile", std::ios::in);
	if (!file.is_open()) {
        std::cerr << "Failed to open Makefile." << std::endl;
        return 1;
    }

	//save Makefile into string
	std::string line;
	std::string content;
	while (std::getline(file, line))
		content += line + "\n";

	//save the args into a string
	std::string arg_str;
	if (argc == 2)
		arg_str += std::string(" ") + args[1];
	else if (argc > 2)
	{
		int i;
		arg_str += std::string(" ") + args[1] + std::string("\\\n");
		for (i = 2; i < argc - 1; i++)
			arg_str += std::string("\t") + args[i] + std::string("\\\n");
		arg_str += std::string("\t") + args[i];
	}

	//find the SRC variable
	size_t pos = content.find(SRC_VAR);
	if (pos == std::string::npos)
	{
		std::cerr << "Failed to find SRC variable." << std::endl;
		return 1;
	}
	pos += std::string(SRC_VAR).length();

	erase_lines(content, pos);
	content.insert(pos, arg_str + std::string("\n"));

	file.close();
	file.open("Makefile", std::ios::out | std::ios::trunc);
    file << content;
	file.close();
}