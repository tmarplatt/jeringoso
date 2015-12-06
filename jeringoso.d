module jeringoso;

import std.stdio, std.regex, std.array;

//tomar una frase y convertirla en jeringoso. da por hecho que los argumentos se tratan de una cadena de texto
void main(string[] args) {
	args.popFront();
	string[] frase;
	foreach (arg; args) {
		auto j = new jeringosear(arg);
		//writeln(arg, ": ", j.papalapabrapa;
		frase ~= j.papalapabrapa;
	}
	writeln(join(args, " "));
	writeln(join(frase, " "));
}

//manipulación de palabras a su forma jeringosa, no susceptible a diptongos
class jeringosear {
	//vocales
	static auto v = "aeiouáéíóú";
	//fin de sílaba
	static auto cs = "r(?:[^r]|$)|t(?:[^rl]|$)|y|s|d(?:[^rl]|$)|f(?:[^rl]|$)|g(?:[^rl]|$)|k(?:[^rl]|$)|l(?:[^l]|$)|z|x|c(?:[^rl]|$)|n|m";
	string palabra, papalapabrapa;
	this(string p) {
		this.palabra = p;
		this.j();
	}
	//convierte una palabra a jeringoso
	void j() {
		auto r = regex(r"([^"~jeringosear.v~"]{0,2})(["~jeringosear.v~"]{1,3})", "ig");
		char fds;
		//silabear
		foreach (m; match(this.palabra, r)) {
			//writeln("PRE:", m.captures.pre() ," S: ", m.captures.hit, " 1: ", m.captures[1], " 2: ", m.captures[2], " POST:", m.captures.post());
			this.papalapabrapa ~= (m.captures.pre().length && fds == m.captures[1][0]) ? m.captures[1][1 .. $] : m.captures[1];
			this.papalapabrapa ~= m.captures[2] ~ "p" ~ m.captures[2];
			if (m.captures.post().length) {
				auto post = regex(r"("~jeringosear.cs~")(?:[^"~jeringosear.v~"]|$)", "ig");
				auto pm = match(m.captures.post()[0 .. 1], post);
				if (pm.captures.length) {
					this.papalapabrapa ~= pm.captures[1];
					fds = cast(char) pm.captures[1][0];
				}
			}
		}
	}
}

unittest {
	//sabe la diferencia entre mayúsuculas y minúsculas acentuadas?
	auto r = regex("[áéíóú]","i");
	auto m = match("LÁTEX", r);
	assert(m.empty == false);
	assert(match("LATEX", r).empty == true);
	//NO distingue vocales acentuadas de no acentuadas
	r = regex("[aeiou]", "i");
	assert(match("LÁT", r).empty == true);
	auto o = new jeringosear("jacinto");
	writeln("JA-CIN-TO: ", o.papalapabrapa);
	o = new jeringosear("cinto");
	writeln("CIN-TO: ", o.papalapabrapa);
	o = new jeringosear("adentro");
	writeln("A-DEN-TRO: ", o.papalapabrapa);
}